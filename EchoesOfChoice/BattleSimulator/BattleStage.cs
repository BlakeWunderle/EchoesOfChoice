using EchoesOfChoice.Battles;
using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.BattleSimulator
{
    public class BattleStage
    {
        public string Name { get; set; }
        public Func<List<BaseFighter>, Battle> BattleFactory { get; set; }
        public int LevelUps { get; set; }
        public Func<List<PartyDefinition>> PartySource { get; set; }
        public double TargetWinRate { get; set; }
        public int ProgressionStage { get; set; }

        // LevelUps = total IncreaseLevel calls the player has received BEFORE entering this battle.
        // CreateFighter distributes these across tiers: 1 as base, 2 as Tier 1, rest as Tier 2.
        //
        // Game flow:
        //   CityStreet (0 lvl) → +1 base lvl → Forest (1 lvl) → T1 upgrade + 1 T1 lvl →
        //   Stage 2 (2 lvl) → +1 T1 lvl → Stage 3 (3 lvl) → T2 upgrade + 1 T2 lvl →
        //   Stage 4 (4 lvl) → +1 T2 lvl → Mirror (5 lvl) → +1 T2 lvl →
        //   ReturnToCity (6 lvl) → recruit + 1 T2 lvl → Elemental (7 lvl)

        public static List<BattleStage> GetAllStages()
        {
            return new List<BattleStage>
            {
                // Progression 0: Base classes, no level ups yet
                new BattleStage
                {
                    Name = "CityStreetBattle",
                    BattleFactory = units => new CityStreetBattle(units),
                    LevelUps = 0,
                    PartySource = PartyComposer.GetBaseParties,
                    TargetWinRate = 0.90,
                    ProgressionStage = 0
                },

                // Progression 1: Base classes, 1 level up (from CityStreet post-battle)
                new BattleStage
                {
                    Name = "ForestBattle",
                    BattleFactory = units => new ForestBattle(units),
                    LevelUps = 1,
                    PartySource = PartyComposer.GetBaseParties,
                    TargetWinRate = 0.86,
                    ProgressionStage = 1
                },

                // Progression 2: Tier 1 classes, 2 total level ups (1 base + 1 Tier 1)
                new BattleStage
                {
                    Name = "SmokeBattle",
                    BattleFactory = units => new SmokeBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.81,
                    ProgressionStage = 2
                },
                new BattleStage
                {
                    Name = "DeepForestBattle",
                    BattleFactory = units => new DeepForestBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.81,
                    ProgressionStage = 2
                },
                new BattleStage
                {
                    Name = "ClearingBattle",
                    BattleFactory = units => new ClearingBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.81,
                    ProgressionStage = 2
                },
                new BattleStage
                {
                    Name = "ShoreBattle",
                    BattleFactory = units => new ShoreBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.81,
                    ProgressionStage = 2
                },
                new BattleStage
                {
                    Name = "RuinsBattle",
                    BattleFactory = units => new RuinsBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.81,
                    ProgressionStage = 2
                },

                // Progression 3: Tier 1 classes, 3 total level ups (1 base + 2 Tier 1)
                new BattleStage
                {
                    Name = "CaveBattle",
                    BattleFactory = units => new CaveBattle(units),
                    LevelUps = 3,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.77,
                    ProgressionStage = 3
                },
                new BattleStage
                {
                    Name = "BeachBattle",
                    BattleFactory = units => new BeachBattle(units),
                    LevelUps = 3,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.77,
                    ProgressionStage = 3
                },
                new BattleStage
                {
                    Name = "PortalBattle",
                    BattleFactory = units => new PortalBattle(units),
                    LevelUps = 3,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.77,
                    ProgressionStage = 3
                },

                // Progression 4: Tier 2 classes, 4 total level ups (1 base + 2 Tier 1 + 1 Tier 2)
                new BattleStage
                {
                    Name = "BoxBattle",
                    BattleFactory = units => new BoxBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.73,
                    ProgressionStage = 4
                },
                new BattleStage
                {
                    Name = "CemeteryBattle",
                    BattleFactory = units => new CemeteryBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.73,
                    ProgressionStage = 4
                },
                new BattleStage
                {
                    Name = "LabBattle",
                    BattleFactory = units => new LabBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.73,
                    ProgressionStage = 4
                },
                new BattleStage
                {
                    Name = "ArmyBattle",
                    BattleFactory = units => new ArmyBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.73,
                    ProgressionStage = 4
                },

                // Progression 5: Mirror battle, 5 total level ups (1 base + 2 Tier 1 + 2 Tier 2)
                new BattleStage
                {
                    Name = "MirrorBattle",
                    BattleFactory = units => new MirrorBattle(units),
                    LevelUps = 5,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.69,
                    ProgressionStage = 5
                },

                // Progression 6: Return to city, 6 total level ups (1 base + 2 Tier 1 + 3 Tier 2)
                new BattleStage
                {
                    Name = "ReturnToCityBattle1",
                    BattleFactory = units => new ReturnToCityBattle1(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.64,
                    ProgressionStage = 6
                },
                new BattleStage
                {
                    Name = "ReturnToCityBattle2",
                    BattleFactory = units => new ReturnToCityBattle2(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.64,
                    ProgressionStage = 6
                },
                new BattleStage
                {
                    Name = "ReturnToCityBattle3",
                    BattleFactory = units => new ReturnToCityBattle3(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.64,
                    ProgressionStage = 6
                },
                new BattleStage
                {
                    Name = "ReturnToCityBattle4",
                    BattleFactory = units => new ReturnToCityBattle4(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.64,
                    ProgressionStage = 6
                },

                // Progression 7: Elemental finale, 7 total level ups (1 base + 2 Tier 1 + 4 Tier 2)
                // 4-member party (3 player + recruit from corresponding ReturnToCityBattle)
                // MirrorBattle randomly assigns which path; each ReturnToCityBattle leads to its
                // matching ElementalBattle. EB1 (Seraph/Fiend recruit) faces all 3 elementals.
                new BattleStage
                {
                    Name = "ElementalBattle1",
                    BattleFactory = units => new ElementalBattle1(units),
                    LevelUps = 7,
                    PartySource = () => PartyComposer.GetTier2PartiesWithRecruits(PartyComposer.ElementalBattle1Recruits),
                    TargetWinRate = 0.60,
                    ProgressionStage = 7
                },
                new BattleStage
                {
                    Name = "ElementalBattle2",
                    BattleFactory = units => new ElementalBattle2(units),
                    LevelUps = 7,
                    PartySource = () => PartyComposer.GetTier2PartiesWithRecruits(PartyComposer.ElementalBattle2Recruits),
                    TargetWinRate = 0.60,
                    ProgressionStage = 7
                },
                new BattleStage
                {
                    Name = "ElementalBattle3",
                    BattleFactory = units => new ElementalBattle3(units),
                    LevelUps = 7,
                    PartySource = () => PartyComposer.GetTier2PartiesWithRecruits(PartyComposer.ElementalBattle3Recruits),
                    TargetWinRate = 0.60,
                    ProgressionStage = 7
                },
                new BattleStage
                {
                    Name = "ElementalBattle4",
                    BattleFactory = units => new ElementalBattle4(units),
                    LevelUps = 7,
                    PartySource = () => PartyComposer.GetTier2PartiesWithRecruits(PartyComposer.ElementalBattle4Recruits),
                    TargetWinRate = 0.60,
                    ProgressionStage = 7
                },
            };
        }
    }
}
