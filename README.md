Trait_AI

Trait_AI is a Rails-based conversational AI system with persistent, user-specific memory, adaptive personality traits, and built-in content moderation.
Unlike stateless chatbots, Trait_AI maintains long-term behavioral state per authenticated user while actively preventing memory poisoning, abusive input, and uncontrolled personality drift through input filtering, warnings, and enforced cooldowns

Features

Persistent Memory: Remembers past conversations with users to provide context-aware responses.
Dynamic Emotional Responses: Adapts tone and sentiment based on the conversation flow.
User Accounts: Supports signup, login, and personalized user sessions.
Secure Authentication: Protects user data with industry-standard authentication practices.
Responsive Interface: Clean, intuitive UI for seamless interactions across devices.

Hard Problems Solved

Persistent AI memory

  * Conversation memory is stored per authenticated user
  * Memory persists across sessions and influences future responses

Memory poisoning prevention

  * Rejects trivial, low-signal, or unsafe inputs from being stored
  * Prevents deliberate manipulation of AI traits via spam or abuse

Content moderation with enforcement

  * Adult / unsafe language detection
  * Warning system for violations
  * Automatic cooldown periods that temporarily block interaction

Adaptive personality system

  * AI traits evolve gradually over time
  * Prevents sudden or extreme personality shifts
  * Trait changes are tied to sustained interaction patterns

State isolation

  * Each user’s memory, traits, and moderation status are fully isolated
  * No cross-user contamination or shared behavioral state

How It Works (High Level)

* Rails controllers manage conversation flow and user state
* Service objects handle:

  * moderation checks
  * memory persistence
  * trait updates
* Models store long-term memory, traits, and cooldown state
* AI responses are generated using:

  * stored memory
  * current trait values
  * moderation and cooldown status

Example Interaction

1. User submits adult or unsafe language
2. Input is rejected and not written to memory
3. Warning is issued to the user
4. After repeated violations, a cooldown period is enforced
5. When interaction resumes:

   * prior memory is intact
   * personality traits persist
   * no degradation from rejected inputs


Technologies

Backend: Ruby on Rails
Frontend: HTML, CSS, JavaScript
Database: PostgreSQL
Authentication: Devise (or your chosen Rails authentication gem)
AI Integration: Custom AI logic for memory and emotional modeling

Getting Started

Prerequisites

Ruby 3.x
Rails 8.x
PostgreSQL
Node.js & Yarn

Demonstration:

https://trait-ai.fly.dev/signup


Installation

Clone the repository:
git clone https://github.com/couchtr26/trait_ai.git
cd trait_ai
Install dependencies:
bundle install
yarn install
Setup the database:
rails db:create
rails db:migrate
Start the Rails server:
rails server
Visit http://localhost:3000 in your browser.

Usage

Sign up or log in to create a personalized experience.
Start chatting with Trait_AI. The chatbot remembers your previous conversations and adapts responses based on your interactions.
Explore dynamic emotional responses by sending messages with varying tone and content.

Why This App Stands Out

Demonstrates full-stack Rails expertise with authentication, AI integration, and responsive UI.
Implements persistent memory and dynamic behavior, showcasing advanced backend logic.
Highlights the ability to combine technical skill with UX considerations—something hiring managers value highly.

Future Improvements

Integration with external NLP services for more advanced AI capabilities.
Analytics dashboard to track conversation trends and user engagement.
Enhanced front-end experience with React or Stimulus.js for richer interactions.

License
MIT License © Thomas Couch
