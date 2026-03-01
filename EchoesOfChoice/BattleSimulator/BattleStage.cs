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
        // CreateFighter distributes these across tiers: 3 as base, 5 as Tier 1, rest as Tier 2.
        //
        // Game flow (14 battles, party of 3, end level ~15):
        //   CityStreet (0 LU) → +1 → WolfForest (1) → +1 → WaypointDefense (2) → +1 →
        //   ForestWaypoint (T0→T1 upgrade, +1) →
        //   Branch4 (4) → +1 → Branch5 (5) → +1 → WildernessOutpost →
        //   SecondWild (6) → +1 → OutpostDefense (7) → +1 → Mirror (8) → +1 →
        //   CityOutskirts (T1→T2 upgrade, +1) →
        //   RavagedStreets (10) → +1 → Tower (11) → +1 →
        //   Choice1 (12) → +1 → Choice2 (13) → +1 → Choice3 (14) → +1 →
        //   StrangerFinal (15)

        public static List<BattleStage> GetAllStages()
        {
            return new List<BattleStage>
            {
                // Progression 0: Base classes, no level ups
                new BattleStage
                {
                    Name = "CityStreetBattle",
                    BattleFactory = units => new CityStreetBattle(units),
                    LevelUps = 0,
                    PartySource = PartyComposer.GetBaseParties,
                    TargetWinRate = 0.90,
                    ProgressionStage = 0
                },

                // Progression 1: Base classes, 1 level up
                new BattleStage
                {
                    Name = "WolfForestBattle",
                    BattleFactory = units => new WolfForestBattle(units),
                    LevelUps = 1,
                    PartySource = PartyComposer.GetBaseParties,
                    TargetWinRate = 0.88,
                    ProgressionStage = 1
                },

                // Progression 2: Base classes, 2 level ups
                new BattleStage
                {
                    Name = "WaypointDefenseBattle",
                    BattleFactory = units => new WaypointDefenseBattle(units),
                    LevelUps = 2,
                    PartySource = PartyComposer.GetBaseParties,
                    TargetWinRate = 0.85,
                    ProgressionStage = 2
                },

                // Progression 3: Tier 1, 4 total level ups (3 base + 1 from T1 upgrade)
                new BattleStage
                {
                    Name = "HighlandBattle",
                    BattleFactory = units => new HighlandBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.83,
                    ProgressionStage = 3
                },
                new BattleStage
                {
                    Name = "DeepForestBattle",
                    BattleFactory = units => new DeepForestBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.83,
                    ProgressionStage = 3
                },
                new BattleStage
                {
                    Name = "ShoreBattle",
                    BattleFactory = units => new ShoreBattle(units),
                    LevelUps = 4,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.83,
                    ProgressionStage = 3
                },

                // Progression 4: Tier 1, 5 total level ups
                new BattleStage
                {
                    Name = "MountainPassBattle",
                    BattleFactory = units => new MountainPassBattle(units),
                    LevelUps = 5,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.80,
                    ProgressionStage = 4
                },
                new BattleStage
                {
                    Name = "CaveBattle",
                    BattleFactory = units => new CaveBattle(units),
                    LevelUps = 5,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.80,
                    ProgressionStage = 4
                },
                new BattleStage
                {
                    Name = "BeachBattle",
                    BattleFactory = units => new BeachBattle(units),
                    LevelUps = 5,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.80,
                    ProgressionStage = 4
                },

                // Progression 5: Tier 1, 6 total level ups (second wilderness choice)
                new BattleStage
                {
                    Name = "CircusBattle",
                    BattleFactory = units => new CircusBattle(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.78,
                    ProgressionStage = 5
                },
                new BattleStage
                {
                    Name = "LabBattle",
                    BattleFactory = units => new LabBattle(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.78,
                    ProgressionStage = 5
                },
                new BattleStage
                {
                    Name = "ArmyBattle",
                    BattleFactory = units => new ArmyBattle(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.78,
                    ProgressionStage = 5
                },
                new BattleStage
                {
                    Name = "CemeteryBattle",
                    BattleFactory = units => new CemeteryBattle(units),
                    LevelUps = 6,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.78,
                    ProgressionStage = 5
                },

                // Progression 6: Tier 1, 7 total level ups (outpost defense)
                new BattleStage
                {
                    Name = "OutpostDefenseBattle",
                    BattleFactory = units => new OutpostDefenseBattle(units),
                    LevelUps = 7,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.75,
                    ProgressionStage = 6
                },

                // Progression 7: Tier 1, 8 total level ups (mirror)
                new BattleStage
                {
                    Name = "MirrorBattle",
                    BattleFactory = units => new MirrorBattle(units),
                    LevelUps = 8,
                    PartySource = PartyComposer.GetTier1Parties,
                    TargetWinRate = 0.72,
                    ProgressionStage = 7
                },

                // Progression 8: Tier 2, 10 total level ups (3 base + 5 T1 + 1 from T1 upgrade + 1 from T2 upgrade)
                new BattleStage
                {
                    Name = "ReturnToCityStreetBattle",
                    BattleFactory = units => new ReturnToCityStreetBattle(units),
                    LevelUps = 10,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.78,
                    ProgressionStage = 8
                },

                // Progression 9: Tier 2, 11 total level ups (stranger tower)
                new BattleStage
                {
                    Name = "StrangerTowerBattle",
                    BattleFactory = units => new StrangerTowerBattle(units),
                    LevelUps = 11,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.75,
                    ProgressionStage = 9
                },

                // Progression 10: Tier 2, 12 total level ups (Act IV choice 1)
                new BattleStage
                {
                    Name = "CorruptedCityBattle",
                    BattleFactory = units => new CorruptedCityBattle(units),
                    LevelUps = 12,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.72,
                    ProgressionStage = 10
                },
                new BattleStage
                {
                    Name = "CorruptedWildsBattle",
                    BattleFactory = units => new CorruptedWildsBattle(units),
                    LevelUps = 12,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.72,
                    ProgressionStage = 10
                },

                // Progression 11: Tier 2, 13 total level ups (Act IV choice 2)
                new BattleStage
                {
                    Name = "TempleBattle",
                    BattleFactory = units => new TempleBattle(units),
                    LevelUps = 13,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.70,
                    ProgressionStage = 11
                },
                new BattleStage
                {
                    Name = "BlightBattle",
                    BattleFactory = units => new BlightBattle(units),
                    LevelUps = 13,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.70,
                    ProgressionStage = 11
                },

                // Progression 12: Tier 2, 14 total level ups (Act IV choice 3)
                new BattleStage
                {
                    Name = "GateBattle",
                    BattleFactory = units => new GateBattle(units),
                    LevelUps = 14,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.68,
                    ProgressionStage = 12
                },
                new BattleStage
                {
                    Name = "DepthsBattle",
                    BattleFactory = units => new DepthsBattle(units),
                    LevelUps = 14,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.68,
                    ProgressionStage = 12
                },

                // Progression 13: Tier 2, 15 total level ups (final boss)
                new BattleStage
                {
                    Name = "StrangerFinalBattle",
                    BattleFactory = units => new StrangerFinalBattle(units),
                    LevelUps = 15,
                    PartySource = PartyComposer.GetTier2Parties,
                    TargetWinRate = 0.60,
                    ProgressionStage = 13
                },
            };
        }
    }
}
