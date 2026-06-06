import 'package:flutter/material.dart';

class Mission {
  final int day;
  final String title;
  final String description;
  final String psychology;
  final int xpReward;
  final int creditReward;
  bool isCompleted;

  Mission({
    required this.day,
    required this.title,
    required this.description,
    required this.psychology,
    required this.xpReward,
    required this.creditReward,
    this.isCompleted = false,
  });
}

class SkillCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Mission> missions;

  SkillCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.missions,
  });
}

List<SkillCategory> getSkillCategories() {
  return [
    SkillCategory(
      title: "Conversation Starters",
      subtitle: "Break the ice without the freeze",
      icon: Icons.chat_bubble_outline,
      color: const Color(0xFFBB86FC),
      missions: List.generate(30, (index) {
        int day = index + 1;
        String title = "Social Step $day";
        String desc = "Take a small step to initiate a brief exchange with someone new.";
        String psych = "Systematic Desensitization: Gradually increasing exposure to feared stimuli helps reduce anxiety over time.";

        if (day == 1) {
          title = "The Easy Ask";
          desc = "Ask a barista or cashier how their day is going.";
          psych = "Exposure therapy: Starting with low-stakes, highly scripted interactions builds momentum without triggering the fight-or-flight response.";
        } else if (day == 7) {
          title = "The Genuine Compliment";
          desc = "Give a specific, non-physical compliment to a colleague or classmate.";
          psych = "Positive Reinforcement: Delivering a compliment shifts focus from internal anxiety to external appreciation, lowering self-consciousness.";
        } else if (day == 15) {
          title = "Sustained Presence";
          desc = "Maintain eye contact for 3 seconds with a stranger while smiling slightly.";
          psych = "Non-verbal validation: Prolonged eye contact signals confidence. A subtle smile prevents it from feeling threatening and encourages approachability.";
        } else if (day == 30) {
          title = "The Initiator";
          desc = "Start a 2-minute conversation with a stranger sitting near you about a shared observation (e.g., the weather, the wait time).";
          psych = "Cognitive Restructuring: Experiencing a positive, unscripted interaction proves that the social world is safer than anxiety predicts.";
        }

        return Mission(
          day: day,
          title: title,
          description: desc,
          psychology: psych,
          xpReward: 10 + day * 2,
          creditReward: 5 + day,
        );
      }),
    ),
    SkillCategory(
      title: "Public Speaking",
      subtitle: "Own the room, quietly",
      icon: Icons.mic_none,
      color: const Color(0xFFEFFF8A),
      missions: List.generate(30, (index) {
        int day = index + 1;
        String title = "Vocal Step $day";
        String desc = "Practice speaking slightly louder or clearer than usual today.";
        String psych = "Vocal projection exercises help normalize the physical sensation of taking up space.";

        if (day == 1) {
          title = "Voice Recording";
          desc = "Record yourself reading a paragraph out loud and listen to it once without judging.";
          psych = "Desensitization to self-image: Hearing your own voice reduces the shock factor and helps you accept your vocal presence.";
        } else if (day == 7) {
          title = "The Meeting Contribution";
          desc = "Prepare one question or comment in advance and deliver it during a meeting or class.";
          psych = "Pre-commitment: Preparing in advance reduces cognitive load during the actual speaking moment, lowering anxiety.";
        } else if (day == 15) {
          title = "Impromptu 60 Seconds";
          desc = "Pick a random topic and speak about it out loud for 60 seconds alone in your room.";
          psych = "State-dependent learning: Practicing speaking without a script trains the brain to trust its ability to formulate thoughts on the fly.";
        } else if (day == 30) {
          title = "The Toast";
          desc = "Give a brief, 1-minute toast or speech to a small group of friends or family.";
          psych = "Flooding (managed): A higher-stakes environment, surrounded by a supportive network, solidifies the newfound confidence in your public speaking identity.";
        }

        return Mission(
          day: day,
          title: title,
          description: desc,
          psychology: psych,
          xpReward: 15 + day * 2,
          creditReward: 5 + day,
        );
      }),
    ),
    SkillCategory(
      title: "Active Listening",
      subtitle: "Hear the unsaid",
      icon: Icons.hearing_outlined,
      color: const Color(0xFF03DAC6),
      missions: List.generate(30, (index) {
        int day = index + 1;
        String title = "Listening Step $day";
        String desc = "Focus entirely on the speaker during a conversation without planning your reply.";
        String psych = "Mindfulness in dialogue: Reduces the cognitive load of formulating responses, allowing for deeper connection.";

        if (day == 1) {
          title = "The Pause";
          desc = "Wait 2 full seconds after someone finishes speaking before you reply.";
          psych = "Pacing: Breaking the habit of immediate response reduces the pressure to 'perform' and shows the speaker you are considering their words.";
        } else if (day == 7) {
          title = "Echoing";
          desc = "Repeat the last three words of a person's sentence back to them as a question.";
          psych = "Mirroring: A psychological technique that subconsciously signals empathy and encourages the speaker to elaborate.";
        } else if (day == 15) {
          title = "Emotion Labeling";
          desc = "Say 'It sounds like you felt [emotion] when that happened' during a conversation.";
          psych = "Affect Labeling: Putting feelings into words diminishes the emotional intensity for the speaker and builds deep rapport.";
        } else if (day == 30) {
          title = "The Deep Dive";
          desc = "Have a 10-minute conversation where you only ask open-ended questions and do not share your own experiences.";
          psych = "Ego-suspension: Removing your own narrative from the interaction allows you to fully inhabit the other person's perspective.";
        }

        return Mission(
          day: day,
          title: title,
          description: desc,
          psychology: psych,
          xpReward: 10 + day,
          creditReward: 5 + (day ~/ 2),
        );
      }),
    ),
    SkillCategory(
      title: "Body Language",
      subtitle: "Speak without words",
      icon: Icons.accessibility_new,
      color: const Color(0xFFFF4081),
      missions: List.generate(30, (index) {
        int day = index + 1;
        String title = "Posture Step $day";
        String desc = "Notice your posture when sitting down and gently correct it.";
        String psych = "Proprioceptive awareness: Grounding yourself in your physical body reduces mental anxiety loops.";

        if (day == 1) {
          title = "The Power Pose";
          desc = "Stand like a superhero (hands on hips, chest out) for 2 minutes in private before leaving the house.";
          psych = "Embodied Cognition: Expansive postures can temporarily reduce cortisol (stress hormone) and increase feelings of power.";
        } else if (day == 7) {
          title = "Uncrossing";
          desc = "Notice when you cross your arms defensively and intentionally let them rest at your sides.";
          psych = "Open Posture: Physical openness signals vulnerability, which paradoxically increases approachability and trust from others.";
        } else if (day == 15) {
          title = "Subtle Mirroring";
          desc = "Match the posture or hand gestures of the person you are talking to, but with a 3-second delay.";
          psych = "Limbic Synchrony: Mimicking body language creates a sense of shared state, deeply enhancing subconscious rapport.";
        } else if (day == 30) {
          title = "Taking Up Space";
          desc = "Sit in a public place and drape your arm over an empty chair next to you, claiming more physical space than usual.";
          psych = "Behavioral Activation: Deliberately breaking the introverted habit of 'shrinking' physically rewires your internal sense of belonging in the world.";
        }

        return Mission(
          day: day,
          title: title,
          description: desc,
          psychology: psych,
          xpReward: 12 + day,
          creditReward: 5 + day,
        );
      }),
    ),
    SkillCategory(
      title: "Persuasion",
      subtitle: "Influence with integrity",
      icon: Icons.psychology_outlined,
      color: const Color(0xFFFFB300),
      missions: List.generate(30, (index) {
        int day = index + 1;
        String title = "Influence Step $day";
        String desc = "Practice framing a request as a mutual benefit rather than a personal favor.";
        String psych = "Framing Effect: People respond better when they perceive a win-win scenario.";

        if (day == 1) {
          title = "The 'Because' Technique";
          desc = "Ask for a small favor and use the word 'because' to justify it (e.g., 'Can I pass you, because I need to reach the door?').";
          psych = "Heuristic Processing: The word 'because' acts as an automatic trigger for compliance, even if the reason is obvious.";
        } else if (day == 7) {
          title = "The Rejection Retreat";
          desc = "Ask for something slightly bigger than you need, accept the 'no', and then ask for what you actually want.";
          psych = "Door-in-the-Face Technique: The second, smaller request feels like a concession, making the other person more likely to agree.";
        } else if (day == 15) {
          title = "Social Proof Observation";
          desc = "Convince a group to choose a specific restaurant by casually mentioning that 'it's supposed to be really popular right now.'";
          psych = "Social Proof: Humans rely heavily on the perceived actions and approvals of the tribe to make decisions.";
        } else if (day == 30) {
          title = "The Soft Close";
          desc = "Negotiate a compromise at work or home by first acknowledging the other person's strongest point.";
          psych = "Tactical Empathy: Validating someone's position disarms their defensiveness, making them highly receptive to your counter-proposal.";
        }

        return Mission(
          day: day,
          title: title,
          description: desc,
          psychology: psych,
          xpReward: 20 + day * 2,
          creditReward: 10 + day,
        );
      }),
    ),
  ];
}
