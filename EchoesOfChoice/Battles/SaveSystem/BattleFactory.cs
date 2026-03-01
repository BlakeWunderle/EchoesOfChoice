using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles.SaveSystem
{
    public static class BattleFactory
    {
        private static readonly Dictionary<string, Func<List<BaseFighter>, Battle>> Constructors =
            new Dictionary<string, Func<List<BaseFighter>, Battle>>
        {
            // Act I
            { "CityStreetBattle", units => new CityStreetBattle(units) },
            { "WolfForestBattle", units => new WolfForestBattle(units) },
            { "WaypointDefenseBattle", units => new WaypointDefenseBattle(units) },
            { "ForestWaypoint", units => new ForestWaypoint(units) },

            // Act II — Branch battles
            { "HighlandBattle", units => new HighlandBattle(units) },
            { "MountainPassBattle", units => new MountainPassBattle(units) },
            { "DeepForestBattle", units => new DeepForestBattle(units) },
            { "CaveBattle", units => new CaveBattle(units) },
            { "ShoreBattle", units => new ShoreBattle(units) },
            { "BeachBattle", units => new BeachBattle(units) },
            { "WildernessOutpost", units => new WildernessOutpost(units) },

            // Act II — Second wilderness + convergence
            { "CircusBattle", units => new CircusBattle(units) },
            { "BoxBattle", units => new CircusBattle(units) },
            { "LabBattle", units => new LabBattle(units) },
            { "ArmyBattle", units => new ArmyBattle(units) },
            { "CemeteryBattle", units => new CemeteryBattle(units) },
            { "OutpostDefenseBattle", units => new OutpostDefenseBattle(units) },
            { "MirrorBattle", units => new MirrorBattle(units) },

            // Act III
            { "CityOutskirtsStop", units => new CityOutskirtsStop(units) },
            { "ReturnToCityStreetBattle", units => new ReturnToCityStreetBattle(units) },
            { "StrangerTowerBattle", units => new StrangerTowerBattle(units) },

            // Act IV
            { "CorruptedCityBattle", units => new CorruptedCityBattle(units) },
            { "CorruptedWildsBattle", units => new CorruptedWildsBattle(units) },
            { "TempleBattle", units => new TempleBattle(units) },
            { "BlightBattle", units => new BlightBattle(units) },
            { "GateBattle", units => new GateBattle(units) },
            { "DepthsBattle", units => new DepthsBattle(units) },

            // Act V
            { "StrangerFinalBattle", units => new StrangerFinalBattle(units) },
        };

        public static Battle CreateBattle(string battleName, List<BaseFighter> units)
        {
            if (!Constructors.TryGetValue(battleName, out var constructor))
            {
                throw new ArgumentException($"Unknown battle: {battleName}");
            }

            return constructor(units);
        }

        public static string GetBattleName(Battle battle)
        {
            return battle.GetType().Name;
        }
    }
}
