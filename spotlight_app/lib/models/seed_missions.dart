import 'mission_model.dart';

/// Repository of curated, high-quality missions for the Spotlight app.
/// Each mission is designed with behavioral psychology principles and RPG gamification.
class SeedMissions {
  static const List<MissionModel> allMissions = [
    // ============= LEVEL 1: RECONNAISSANCE (Digital/Observation) =============
    // These missions require no in-person social interaction. Pure observation mode.

    MissionModel(
      id: 'l1_m001',
      title: 'Social Radar Calibration',
      description:
          'Observe a public space (café, park, mall) for 10-15 minutes. Note down 3 interesting conversations or social patterns you notice without participating. Objective: Develop observer\'s perspective.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 50,
      courageXp: 30,
      category: 'Reconnaissance',
      emoji: '👁️',
      colorTheme: '#7AC74F', // Soothing green
      estimatedMinutes: 15,
    ),

    MissionModel(
      id: 'l1_m002',
      title: 'Digital Presence Mission',
      description:
          'Leave a thoughtful, non-controversial comment on a social media post in your hobby/interest area. Keep it brief (under 20 words) and genuine.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 40,
      courageXp: 25,
      category: 'Reconnaissance',
      emoji: '💬',
      colorTheme: '#7AC74F',
      estimatedMinutes: 5,
    ),

    MissionModel(
      id: 'l1_m003',
      title: 'Email Infiltration',
      description:
          'Send one genuine email or message to someone you haven\'t talked to in a while. Could be an old classmate, colleague, or acquaintance. No pressure to start a long conversation—a simple "Hey, just thinking about you" counts as a successful mission.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 60,
      courageXp: 35,
      category: 'Reconnaissance',
      emoji: '📧',
      colorTheme: '#7AC74F',
      estimatedMinutes: 10,
    ),

    MissionModel(
      id: 'l1_m004',
      title: 'Like & Learn',
      description:
          'Engage with one piece of content online from someone in your network (like, heart, or retweet). Then visit their profile and read about what they\'ve been up to.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 35,
      courageXp: 20,
      category: 'Reconnaissance',
      emoji: '❤️',
      colorTheme: '#7AC74F',
      estimatedMinutes: 8,
    ),

    // ============= LEVEL 2: PHYSICAL PRESENCE (Being Around People) =============
    // These missions require being in proximity to others, but no mandatory interaction.

    MissionModel(
      id: 'l2_m001',
      title: 'Crowd Immersion',
      description:
          'Spend 20 minutes in a moderately populated public space (library, shopping center, public transit). No task required—just exist in the space, observe the baseline comfort level.',
      levelOfExposure: 2,
      escapeHatchInstruction: 'If anxiety peaks, step outside for 2 minutes, then re-enter.',
      successXp: 80,
      courageXp: 50,
      category: 'Infiltration',
      emoji: '🏪',
      colorTheme: '#F4D35E', // Warm yellow
      estimatedMinutes: 20,
    ),

    MissionModel(
      id: 'l2_m002',
      title: 'Vendor Dialogue (No Purchase)',
      description:
          'Visit a small shop or café. Browse for 5 minutes, then ask a staff member one simple question: "Where would you recommend for [category]?" or "What\'s popular right now?" Do NOT feel obligated to buy anything.',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'Nervous? Text yourself the question first, then ask it out loud to the person.',
      successXp: 90,
      courageXp: 55,
      category: 'Infiltration',
      emoji: '☕',
      colorTheme: '#F4D35E',
      estimatedMinutes: 12,
    ),

    MissionModel(
      id: 'l2_m003',
      title: 'Parallel Play Protocol',
      description:
          'Attend a low-key group activity where interaction is not expected (movie, class, group workout). You\'re there to participate individually, not lead conversations.',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'Sit in the back row or a less central spot. Have a podcast queued up to listen to before/after if needed.',
      successXp: 100,
      courageXp: 60,
      category: 'Infiltration',
      emoji: '🎬',
      colorTheme: '#F4D35E',
      estimatedMinutes: 60,
    ),

    MissionModel(
      id: 'l2_m004',
      title: 'Compliment Delivery System',
      description:
          'Give one genuine, specific compliment to someone you don\'t know well—coworker, classmate, or acquaintance. Something like "I really liked your presentation yesterday" or "That\'s a cool shirt!"',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'Write it down first. Keep it short. One sentence is enough.',
      successXp: 85,
      courageXp: 50,
      category: 'Infiltration',
      emoji: '⭐',
      colorTheme: '#F4D35E',
      estimatedMinutes: 5,
    ),

    // ============= LEVEL 3: SHORT SCRIPTED VERBAL INTERACTION =============
    // These missions require brief, structured verbal exchanges.

    MissionModel(
      id: 'l3_m001',
      title: 'Barista Negotiation',
      description:
          'Order a coffee with a slight customization. Ask for something specific: "Can I get that oat milk instead?" or "A little less ice, please?" Make eye contact if possible. Treat it like a mini transaction, not a social event.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'Script: "Hi! Could I get a [drink] with [modification]? Thanks!" Pause if you need to breathe.',
      successXp: 100,
      courageXp: 65,
      category: 'Social Engineering',
      emoji: '☕',
      colorTheme: '#FF9F45', // Warm orange
      estimatedMinutes: 8,
    ),

    MissionModel(
      id: 'l3_m002',
      title: 'Checkout Chit-Chat',
      description:
          'At a store or register, make ONE neutral observation or comment to the cashier. "Quiet today, huh?" or "That\'s a cool pin!" Keep it light and brief. You\'re testing the waters, not forming a friendship.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'If they respond coldly, smile and say "Have a good day!" That counts as mission success.',
      successXp: 85,
      courageXp: 60,
      category: 'Social Engineering',
      emoji: '💳',
      colorTheme: '#FF9F45',
      estimatedMinutes: 5,
    ),

    MissionModel(
      id: 'l3_m003',
      title: 'Phone Call Protocol',
      description:
          'Make a phone call to a business (store hours check, appointment confirmation, service inquiry). You\'ll have a defined script, so the interaction has clear boundaries. No open-ended chat required.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'Write the exact question/information you need BEFORE calling. Read from your paper if needed. The person on the line won\'t judge you.',
      successXp: 120,
      courageXp: 70,
      category: 'Social Engineering',
      emoji: '☎️',
      colorTheme: '#FF9F45',
      estimatedMinutes: 10,
    ),

    MissionModel(
      id: 'l3_m004',
      title: 'Group Chat Participation',
      description:
          'Post one thoughtful message in a group chat (class, team, hobby group). Not a reaction—an actual message. Could be answering a question, sharing info, or asking for advice.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'If you\'re scared of judgment, write it in a note app first. Then paste it. Taking 10 minutes to draft is fine—this is about showing up.',
      successXp: 90,
      courageXp: 55,
      category: 'Social Engineering',
      emoji: '💬',
      colorTheme: '#FF9F45',
      estimatedMinutes: 10,
    ),

    // ============= LEVEL 4: INTERACTIVE MICRO-CONVERSATIONS =============
    // These missions require reciprocal dialogue and genuine social presence.

    MissionModel(
      id: 'l4_m001',
      title: 'Casual Hangout Initiation',
      description:
          'Suggest a low-pressure hangout to one person you know: "Want to grab coffee this week?" or "See a movie sometime?" A simple text is fine. The mission succeeds whether they say yes or no—you\'re practicing the ask.',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'Nervous about rejection? Remember: asking is the brave part. "No" doesn\'t mean anything about your worth. Have a reason ready: "I just thought it\'d be nice to catch up."',
      successXp: 150,
      courageXp: 90,
      category: 'Micro-Conversation',
      emoji: '☕',
      colorTheme: '#E63946', // Alert coral/red
      estimatedMinutes: 5,
    ),

    MissionModel(
      id: 'l4_m002',
      title: 'Active Listening Deep Dive',
      description:
          'Have a 10-15 minute conversation with one person. Ask TWO follow-up questions based on what they say. Goal: Make them feel genuinely heard. You\'re not performing—you\'re connecting.',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'Stressed? Remember: People LIKE talking about themselves. Ask open-ended questions: "How did that make you feel?" or "What happened next?"',
      successXp: 140,
      courageXp: 85,
      category: 'Micro-Conversation',
      emoji: '👂',
      colorTheme: '#E63946',
      estimatedMinutes: 15,
    ),

    MissionModel(
      id: 'l4_m003',
      title: 'Group Integration',
      description:
          'Join an in-person group activity (game night, study group, hobby meetup) and engage in at least one conversation with someone new or semi-new. No need to be the life of the party—just participate authentically.',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'Arriving solo to a group? Find the quietest person, ask them a question about the activity. Introverts often bond over low-pressure observations.',
      successXp: 160,
      courageXp: 100,
      category: 'Micro-Conversation',
      emoji: '🎲',
      colorTheme: '#E63946',
      estimatedMinutes: 60,
    ),

    MissionModel(
      id: 'l4_m004',
      title: 'Authentic Self-Disclosure',
      description:
          'Share something genuinely personal (but not overly intimate on first share) with someone you trust or are building trust with. Could be: "I\'ve been nervous about [X]" or "I really enjoyed [experience]."',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'Start small. Vulnerability builds trust. If they respond poorly, that\'s about them—not you. You still showed courage.',
      successXp: 170,
      courageXp: 105,
      category: 'Micro-Conversation',
      emoji: '💭',
      colorTheme: '#E63946',
      estimatedMinutes: 15,
    ),

    // ============= ADDITIONAL LEVEL 1 MISSIONS =============
    MissionModel(
      id: 'l1_m005',
      title: 'Community Hub Visit',
      description:
          'Spend 15 minutes in a community space: library, community center, or public park. Just be present, observe the vibe, and soak in the atmosphere. No participation required—just presence.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 45,
      courageXp: 28,
      category: 'Reconnaissance',
      emoji: '📚',
      colorTheme: '#7AC74F',
      estimatedMinutes: 15,
    ),

    MissionModel(
      id: 'l1_m006',
      title: 'Online Forum Lurker to Commenter',
      description:
          'Find an online forum or Reddit thread related to your interests. Read through discussions for 10 minutes, then post ONE thoughtful comment or question.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 55,
      courageXp: 32,
      category: 'Reconnaissance',
      emoji: '💻',
      colorTheme: '#7AC74F',
      estimatedMinutes: 15,
    ),

    MissionModel(
      id: 'l1_m007',
      title: 'Appreciation React',
      description:
          'Find a friend or acquaintance\'s social media post you genuinely appreciate. React to it (like, emoji, or supportive comment). Make it authentic—you\'re celebrating them, not performing.',
      levelOfExposure: 1,
      escapeHatchInstruction: null,
      successXp: 35,
      courageXp: 22,
      category: 'Reconnaissance',
      emoji: '🌟',
      colorTheme: '#7AC74F',
      estimatedMinutes: 5,
    ),

    // ============= ADDITIONAL LEVEL 2 MISSIONS =============
    MissionModel(
      id: 'l2_m005',
      title: 'Workout Warrior',
      description:
          'Attend a group fitness class (yoga, gym, dance, etc.). You don\'t need to talk to anyone—just show up and participate at your own pace. You\'re part of the community.',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'Arrive early or late to avoid peak crowds. Wear headphones if it helps you feel grounded.',
      successXp: 110,
      courageXp: 65,
      category: 'Infiltration',
      emoji: '💪',
      colorTheme: '#F4D35E',
      estimatedMinutes: 60,
    ),

    MissionModel(
      id: 'l2_m006',
      title: 'Bookstore or Store Exploration',
      description:
          'Browse a bookstore, coffee shop, or interesting retail space for 20 minutes. Ask one staff member a simple question like "Where\'s the [section]?" or "Can you recommend something?"',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'Write down your question before asking. Staff are trained to help—they expect questions.',
      successXp: 95,
      courageXp: 55,
      category: 'Infiltration',
      emoji: '🏬',
      colorTheme: '#F4D35E',
      estimatedMinutes: 25,
    ),

    MissionModel(
      id: 'l2_m007',
      title: 'Event Attendance Solo',
      description:
          'Attend a low-key community event: farmers market, art walk, festival, or cultural event. Stay for 20-30 minutes. No networking required—just be present and observe.',
      levelOfExposure: 2,
      escapeHatchInstruction:
          'If overwhelmed, grab a drink/snack and find a quiet corner. Being at the event is the win.',
      successXp: 105,
      courageXp: 60,
      category: 'Infiltration',
      emoji: '🎪',
      colorTheme: '#F4D35E',
      estimatedMinutes: 30,
    ),

    // ============= ADDITIONAL LEVEL 3 MISSIONS =============
    MissionModel(
      id: 'l3_m005',
      title: 'Question Asker',
      description:
          'In a class, meeting, or group setting, ask ONE genuine question out loud. Could be clarification, a curious follow-up, or honest feedback. Your voice matters.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'Raise your hand first to signal intent. Take a breath. Your question doesn\'t need to be perfect—authenticity beats polish.',
      successXp: 110,
      courageXp: 70,
      category: 'Social Engineering',
      emoji: '✋',
      colorTheme: '#FF9F45',
      estimatedMinutes: 5,
    ),

    MissionModel(
      id: 'l3_m006',
      title: 'Door Dash or Delivery Interaction',
      description:
          'When a delivery person arrives (food, package, etc.), open the door, make brief eye contact, say "thank you" or "have a great day" as you exchange. Real human connection, 10 seconds long.',
      levelOfExposure: 3,
      escapeHatchInstruction:
          'If you can\'t do eye contact, just a smile and "thanks" is enough. They appreciate acknowledgment.',
      successXp: 85,
      courageXp: 55,
      category: 'Social Engineering',
      emoji: '🚪',
      colorTheme: '#FF9F45',
      estimatedMinutes: 2,
    ),

    // ============= ADDITIONAL LEVEL 4 MISSIONS =============
    MissionModel(
      id: 'l4_m005',
      title: 'Hobby Connection',
      description:
          'Find someone (online or in-person) who shares your hobby/interest. Have a genuine 10-15 minute conversation about your shared passion. Talk about what you love—this is easy territory.',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'Common ground = low pressure. Ask them about their experience. People love sharing passions.',
      successXp: 155,
      courageXp: 95,
      category: 'Micro-Conversation',
      emoji: '🎮',
      colorTheme: '#E63946',
      estimatedMinutes: 15,
    ),

    MissionModel(
      id: 'l4_m006',
      title: 'Peer Support Moment',
      description:
          'Reach out to someone you know who might be going through a tough time. Send a message or ask them to talk. Listen more than you speak. Be the friend you\'d want to have.',
      levelOfExposure: 4,
      escapeHatchInstruction:
          'You don\'t need to "fix" anything. Just showing you care is enough. Vulnerability connects people.',
      successXp: 180,
      courageXp: 110,
      category: 'Micro-Conversation',
      emoji: '🤝',
      colorTheme: '#E63946',
      estimatedMinutes: 20,
    ),
  ];

  /// Get all missions available at a specific exposure level
  static List<MissionModel> getMissionsByLevel(int level) {
    return allMissions
        .where((mission) => mission.levelOfExposure == level)
        .toList();
  }

  /// Get a single mission by ID
  static MissionModel? getMissionById(String id) {
    try {
      return allMissions.firstWhere((mission) => mission.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get a random sample of missions filtered by max exposure level
  static List<MissionModel> getRandomMissionPool(int maxExposureLevel, {int count = 3}) {
    final available = allMissions
        .where((mission) => mission.levelOfExposure <= maxExposureLevel)
        .toList();

    available.shuffle();
    return available.take(count).toList();
  }
}
