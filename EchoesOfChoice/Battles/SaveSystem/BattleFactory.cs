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
            { "CityStreetBattle", units => new CityStreetBattle(units) },
            { "ForestBattle", units => new ForestBattle(units) },
            { "SmokeBattle", units => new SmokeBattle(units) },
            { "DeepForestBattle", units => new DeepForestBattle(units) },
            { "ClearingBattle", units => new ClearingBattle(units) },
            { "CaveBattle", units => new CaveBattle(units) },
            { "BeachBattle", units => new BeachBattle(units) },
            { "PortalBattle", units => new PortalBattle(units) },
            { "ShoreBattle", units => new ShoreBattle(units) },
            { "RuinsBattle", units => new RuinsBattle(units) },
            { "BoxBattle", units => new BoxBattle(units) },
            { "CemeteryBattle", units => new CemeteryBattle(units) },
            { "LabBattle", units => new LabBattle(units) },
            { "ArmyBattle", units => new ArmyBattle(units) },
            { "MirrorBattle", units => new MirrorBattle(units) },
            { "ReturnToCityBattle1", units => new ReturnToCityBattle1(units) },
            { "ReturnToCityBattle2", units => new ReturnToCityBattle2(units) },
            { "ReturnToCityBattle3", units => new ReturnToCityBattle3(units) },
            { "ReturnToCityBattle4", units => new ReturnToCityBattle4(units) },
            { "ElementalBattle1", units => new ElementalBattle1(units) },
            { "ElementalBattle2", units => new ElementalBattle2(units) },
            { "ElementalBattle3", units => new ElementalBattle3(units) },
            { "ElementalBattle4", units => new ElementalBattle4(units) },
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
