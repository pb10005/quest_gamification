## 0.1.0

- Initial release
- `GamificationEngine`: unified entry point for XP, streak, and badge processing in a single `recordEvent()` call
- `XpEngine`: XP award and level-up detection with `fixed` and `linear` level formulas
- `StreakEngine`: daily streak tracking with streak shield system (earn a shield every N days, consumes on missed day)
- `BadgeEngine`: condition-based badge evaluation; add badges as data without modifying engine code
- `QuestConfig`: injectable configuration with preset factories (`fitness`, `sleep`, `mental`, `corporate`)
- `UserProgress`: immutable state model with `copyWith`, `toMap`/`fromMap` serialization
- Storage adapters: `FirestoreProgressAdapter` (callback design), `HiveProgressAdapter`, `InMemoryProgressRepository`
- UI widgets: `QuestXpBar`, `QuestLevelCard`, `QuestStreakCard`, `QuestBadgeGrid`, `QuestAchievementToast`
