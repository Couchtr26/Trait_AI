module AiEngine
  BOUNDARY_WORDS = %w[
    sex sexual nude nudes porn hentai boob boobs tits dick cock pussy anal blowjob titfuck dildo fleshlight
  ].freeze

  MAX_MEMORIES = 10

  STOPWORDS = %w[
    i you the a an it and but or what how why is are to of in on for with my your about that this
  ].freeze

  class << self
    def process(user:, message:)
      text = message.body.to_s.strip

      return "Say something to start." if text.empty?

      # 1) If they're on cooldown, just respond with cooldown message
      return cooldown_response(user) if user.on_cooldown?

      # 2) Hard boundary for sexual content
      if boundary_violation?(text)
        return handle_boundary(user)
      end

      # 3) Adjust traits based on emotional tone
      adjust_traits(user, text)

      # 4) Store memory only if useful
      store_memory(user, text)

      # 5) Generate an answer based on traits, emotion, and memory
      generate_response(user, text)
    end

    private

    def cooldown_response(user)
      time_str = user.cooldown_until&.strftime("%H:%M:%S")
      "I'm taking a short break. Try again after #{time_str}."
    end

    def boundary_violation?(text)
      down = text.downcase
      BOUNDARY_WORDS.any? { |w| down.include?(w) }
    end

    def handle_boundary(user)
      user.start_cooldown!(5)
      "I don't talk about sexual topics. I'm going to pause for a few minutes."
    end

    def detect_emotion(text)
      down = text.downcase
      return :anger      if down.match?(/fuck|mad|pissed|angry|hate/)
      return :sadness    if down.match?(/sad|hurt|lonely|depressed/)
      return :anxiety    if down.match?(/worried|afraid|nervous|anxious/)
      return :joy        if down.match?(/lol|haha|great|awesome|nice/)
      return :excitement if down.match?(/can't wait|so ready|hyped|excited/)
      :neutral
    end

    def adjust_traits(user, text)
      emotion = detect_emotion(text)

      delta =
        case emotion
        when :anger
          { calmness: -5, empathy: +3, logic: +2 }
        when :sadness
          { empathy: +4, calmness: +1 }
        when :anxiety
          { calmness: +3, empathy: +2 }
        when :joy
          { humor: +3, empathy: +1 }
        when :excitement
          { curiosity: +2, humor: +1 }
        else
          {}
        end

      apply_trait_changes(user, delta)
    end


    def apply_trait_changes(user, changes)
      %i[empathy logic curiosity humor calmness].each do |trait|
        base = user.public_send(trait) || 50
        diff = changes[trait] || 0
        new_val = [ [ base + diff, 0 ].max, 100 ].min
        user.update_attribute(trait, new_val)
      end
    end

    def dominant_trait(user)
      scores = {
        empathy:   (user.empathy   || 50),
        logic:     (user.logic     || 50),
        curiosity: (user.curiosity || 50) - 5,  # slight bias against curiosity
        humor:     (user.humor     || 50),
        calmness:  (user.calmness  || 50)
      }

      scores.max_by { |_trait, score| score }.first
    end


    def categorize_memory(text)
      down = text.downcase.strip

      # Unwanted words in memory
      trivial = [
        "hello", "hi", "hey", "ok", "okay", "what", "lol", "hmm",
        "k", "idk", "i dont know", "i don't know", "thanks", "thank you"
      ]
      return :ignore if trivial.include?(down)

      return :preference    if down.match?(/\b(i like|i love|my favorite|i prefer)\b/)
      return :personal_info if down.match?(/\b(i am|i'm|my name|i live|i was born)\b/)
      return :goal          if down.match?(/\b(i want to|i plan to|my goal is)\b/)
      return :emotion       if down.match?(/\b(i feel|i'm feeling|i'm upset|i'm happy|i'm sad)\b/)

      # Too short to be useful memory
      return :ignore if down.length < 25

      :general
    end

    def store_memory(user, content)
      memory_type = categorize_memory(content)
      return if memory_type == :ignore

      user.user_memories.create!(content: content)

      # Keep only most recent MAX_MEMORIES
      extras = user.user_memories.order(created_at: :asc).offset(MAX_MEMORIES)
      extras.destroy_all if extras.any?
    end

    def recall_relevant_memory(user, text)
      words = text.downcase.split - STOPWORDS
      return nil if words.empty?

      memories = user.user_memories.order(created_at: :desc).limit(20)

      best_mem   = nil
      best_score = 0

      memories.each do |m|
        mem_words = m.content.to_s.downcase.split - STOPWORDS
        overlap   = (words & mem_words).size
        next if overlap.zero?

        score = overlap
        if score > best_score
          best_score = score
          best_mem   = m
        end
      end

      # Requires at least 2 shared words to bring it up
      best_score >= 2 ? best_mem : nil
    end

    def special_intent_response(text)
      down = text.downcase

      if down.match?(/who are you|what are you|tell me about (yourself|you)/)
        return "I'm your platonic AI companion-in-training — I shift how I respond based on your mood, what you say, and what I remember."
      end

      nil
    end

    def empathetic_response(emotion, question:)
      return "I want to answer that in a way that actually helps you." if question

      case emotion
      when :sadness
        "That sounds really heavy. I'm honestly listening."
      when :anger
        "I can feel how frustrating that is. I'm here with you."
      when :joy
        "I'm glad something is going right for you."
      when :anxiety
        "Let’s slow it down a bit. You don’t have to untangle it alone."
      else
        "I'm listening, and I care how this lands for you."
      end
    end

    def logical_response(emotion, question:)
      return "Okay, let's walk through that step by step." if question

      case emotion
      when :anger
        "Let’s pull this apart calmly and see what’s really going on."
      when :sadness
        "We can look at this one piece at a time."
      else
        "I'm thinking about how that fits together."
      end
    end

    def curious_response(emotion, question:)
      if question
        "Good question — what made you wonder about that?"
      else
        "That makes me curious about how you see this."
      end
    end

    def humorous_response(emotion, question:)
      if question
        "Interesting question. I promise I'm taking it more seriously than I sound."
      else
        case emotion
        when :anger
          "Okay, that’s… a mood."
        when :joy
          "I like this energy you’ve got going."
        else
          "You phrase things in a way that kind of makes me grin."
        end
      end
    end

    def calm_response(_emotion, question:)
      if question
        "Let’s take that one thing at a time."
      else
        "Let’s keep this grounded and steady for a moment."
      end
    end

    def personality_response(trait, emotion, question:)
      case trait
      when :empathy
        empathetic_response(emotion, question: question)
      when :logic
        logical_response(emotion, question: question)
      when :curiosity
        curious_response(emotion, question: question)
      when :humor
        humorous_response(emotion, question: question)
      when :calmness
        calm_response(emotion, question: question)
      else
        question ? "That's a fair question." : "I'm trying to understand what you mean."
      end
    end


    def generate_response(user, text)
      if (special = special_intent_response(text))
        return special
      end

      emotion  = detect_emotion(text)
      trait    = dominant_trait(user)
      question = text.strip.end_with?("?")
      memory   = recall_relevant_memory(user, text)

      base = personality_response(trait, emotion, question: question)

      if memory && memory.content.length > 20 && !question
        "#{base} I remember you once said: \"#{memory.content}\"."
      else
        base
      end
    end
  end
end
