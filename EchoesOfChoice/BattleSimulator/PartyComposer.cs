using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using EchoesOfChoice.CharacterClasses.Entertainer;
using EchoesOfChoice.CharacterClasses.Fighter;
using EchoesOfChoice.CharacterClasses.Mage;
using EchoesOfChoice.CharacterClasses.Scholar;
using EchoesOfChoice.CharacterClasses.Wildling;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EchoesOfChoice.BattleSimulator
{
    public class RecruitSpec
    {
        public string Type { get; }
        public int LevelUps { get; }
        public int HealthAdj { get; }
        public int MagicAttackAdj { get; }
        public int PhysicalAttackAdj { get; }

        public RecruitSpec(string type, int levelUps, int healthAdj = 0, int magicAttackAdj = 0, int physicalAttackAdj = 0)
        {
            Type = type;
            LevelUps = levelUps;
            HealthAdj = healthAdj;
            MagicAttackAdj = magicAttackAdj;
            PhysicalAttackAdj = physicalAttackAdj;
        }
    }

    public static class PartyComposer
    {
        // Mirrors game flow: 1 level up as base (after CityStreet), 2 as Tier 1 (after Forest + Stage 2)
        private const int LevelsAsBase = 1;
        private const int LevelsAsTier1 = 2;

        public static List<BaseFighter> CreateBaseClasses()
        {
            return new List<BaseFighter>
            {
                new Squire(),
                new CharacterClasses.Mage.Mage(),
                new CharacterClasses.Entertainer.Entertainer(),
                new Scholar(),
                new CharacterClasses.Wildling.Wildling()
            };
        }

        public static Dictionary<string, UpgradeItemEnum[]> Tier1Upgrades = new()
        {
            ["Squire"] = new[] { UpgradeItemEnum.Sword, UpgradeItemEnum.Bow, UpgradeItemEnum.Headband },
            ["Mage"] = new[] { UpgradeItemEnum.RedStone, UpgradeItemEnum.WhiteStone },
            ["Entertainer"] = new[] { UpgradeItemEnum.Guitar, UpgradeItemEnum.Slippers, UpgradeItemEnum.Scroll },
            ["Scholar"] = new[] { UpgradeItemEnum.Crystal, UpgradeItemEnum.Textbook, UpgradeItemEnum.Abacus },
            ["Wildling"] = new[] { UpgradeItemEnum.Herbs, UpgradeItemEnum.Totem, UpgradeItemEnum.BeastClaw }
        };

        public static Dictionary<string, UpgradeItemEnum[]> Tier2Upgrades = new()
        {
            ["Duelist"] = new[] { UpgradeItemEnum.Horse, UpgradeItemEnum.Spear },
            ["Ranger"] = new[] { UpgradeItemEnum.Gun, UpgradeItemEnum.Trap },
            ["Martial Artist"] = new[] { UpgradeItemEnum.Sword, UpgradeItemEnum.Staff },
            ["Invoker"] = new[] { UpgradeItemEnum.FireStone, UpgradeItemEnum.WaterStone, UpgradeItemEnum.LightningStone },
            ["Acolyte"] = new[] { UpgradeItemEnum.Hammer, UpgradeItemEnum.HolyBook, UpgradeItemEnum.DarkOrb },
            ["Bard"] = new[] { UpgradeItemEnum.Hat, UpgradeItemEnum.WarHorn },
            ["Dervish"] = new[] { UpgradeItemEnum.Light, UpgradeItemEnum.Paint },
            ["Orator"] = new[] { UpgradeItemEnum.Pen, UpgradeItemEnum.Medal },
            ["Arithmancer"] = new[] { UpgradeItemEnum.ClockworkCore, UpgradeItemEnum.Computer },
            ["Philosopher"] = new[] { UpgradeItemEnum.TimeMachine, UpgradeItemEnum.Telescope },
            ["Artificer"] = new[] { UpgradeItemEnum.Potion, UpgradeItemEnum.Hammer },
            ["Herbalist"] = new[] { UpgradeItemEnum.Venom, UpgradeItemEnum.Seedling },
            ["Shaman"] = new[] { UpgradeItemEnum.Shrunkenhead, UpgradeItemEnum.SpiritOrb },
            ["Beastcaller"] = new[] { UpgradeItemEnum.Feather, UpgradeItemEnum.Pelt }
        };

        public static BaseFighter CreateFighter(string baseType, UpgradeItemEnum? tier1Item, UpgradeItemEnum? tier2Item, int totalLevelUps)
        {
            BaseFighter fighter = baseType switch
            {
                "Squire" => new Squire(),
                "Mage" => new CharacterClasses.Mage.Mage(),
                "Entertainer" => new CharacterClasses.Entertainer.Entertainer(),
                "Scholar" => new Scholar(),
                "Wildling" => new CharacterClasses.Wildling.Wildling(),
                _ => new Squire()
            };

            fighter.CharacterName = fighter.CharacterType;
            fighter.IsUserControlled = false;

            int remaining = totalLevelUps;

            // Level ups as base class before Tier 1 upgrade
            int baseLevels = tier1Item.HasValue ? Math.Min(remaining, LevelsAsBase) : remaining;
            for (int i = 0; i < baseLevels; i++)
                fighter.IncreaseLevel();
            remaining -= baseLevels;

            if (tier1Item.HasValue)
            {
                fighter = fighter.UpgradeClass(tier1Item.Value);
                fighter.IsUserControlled = false;

                // Level ups as Tier 1 before Tier 2 upgrade
                int t1Levels = tier2Item.HasValue ? Math.Min(remaining, LevelsAsTier1) : remaining;
                for (int i = 0; i < t1Levels; i++)
                    fighter.IncreaseLevel();
                remaining -= t1Levels;
            }

            if (tier2Item.HasValue)
            {
                fighter = fighter.UpgradeClass(tier2Item.Value);
                fighter.IsUserControlled = false;

                // Remaining level ups as Tier 2
                for (int i = 0; i < remaining; i++)
                    fighter.IncreaseLevel();
            }

            return fighter;
        }

        // Recruit specs per ElementalBattle, matching each ReturnToCityBattle's construction logic.
        // Each recruit gets stat adjustments / pre-clone level ups from its battle constructor,
        // plus 1 IncreaseLevel from PostBattleInteraction (included in LevelUps total).
        public static readonly RecruitSpec[] ElementalBattle1Recruits = new[]
        {
            new RecruitSpec("Seraph", 0, healthAdj: -20, magicAttackAdj: -7, physicalAttackAdj: -5),
            new RecruitSpec("Fiend", 0, healthAdj: 20, magicAttackAdj: 5, physicalAttackAdj: 7),
        };

        public static readonly RecruitSpec[] ElementalBattle2Recruits = new[]
        {
            new RecruitSpec("Druid", 0, healthAdj: -18, magicAttackAdj: -6, physicalAttackAdj: -4),
            new RecruitSpec("Necromancer", 0, healthAdj: 18, magicAttackAdj: 4, physicalAttackAdj: 6),
        };

        public static readonly RecruitSpec[] ElementalBattle3Recruits = new[]
        {
            new RecruitSpec("Psion", 0, healthAdj: -10, magicAttackAdj: -8),
            new RecruitSpec("Runewright", 0, healthAdj: 5, magicAttackAdj: 6, physicalAttackAdj: 4),
        };

        public static readonly RecruitSpec[] ElementalBattle4Recruits = new[]
        {
            new RecruitSpec("Shaman", 0, healthAdj: -22, magicAttackAdj: -6, physicalAttackAdj: -3),
            new RecruitSpec("Warlock", 0, healthAdj: 22, magicAttackAdj: 4, physicalAttackAdj: 6),
        };

        public static BaseFighter CreateRecruit(RecruitSpec spec)
        {
            BaseFighter recruit = spec.Type switch
            {
                "Seraph" => new Seraph(),
                "Fiend" => new Fiend(),
                "Druid" => new Druid(),
                "Necromancer" => new Necromancer(),
                "Psion" => new Psion(),
                "Runewright" => new Runewright(),
                "Shaman" => new EchoesOfChoice.CharacterClasses.Enemies.Shaman(),
                "Warlock" => new EchoesOfChoice.CharacterClasses.Enemies.Warlock(),
                _ => throw new ArgumentException($"Unknown recruit type: {spec.Type}")
            };

            recruit.CharacterName = recruit.CharacterType;
            recruit.IsUserControlled = false;

            recruit.Health += spec.HealthAdj;
            recruit.MaxHealth += spec.HealthAdj;
            recruit.MagicAttack += spec.MagicAttackAdj;
            recruit.PhysicalAttack += spec.PhysicalAttackAdj;

            for (int i = 0; i < spec.LevelUps; i++)
                recruit.IncreaseLevel();

            return recruit;
        }

        private static readonly string[] BaseTypes = { "Squire", "Mage", "Entertainer", "Scholar", "Wildling" };

        private static readonly Dictionary<(string, UpgradeItemEnum?, UpgradeItemEnum?), string> _classNameCache = new();

        public static string GetClassName(string baseType, UpgradeItemEnum? t1, UpgradeItemEnum? t2)
        {
            var key = (baseType, t1, t2);
            if (_classNameCache.TryGetValue(key, out var name))
                return name;
            var fighter = CreateFighter(baseType, t1, t2, 0);
            name = fighter.CharacterType;
            _classNameCache[key] = name;
            return name;
        }

        public static List<PartyDefinition> GetBaseParties()
        {
            var parties = new List<PartyDefinition>();
            for (int i = 0; i < 5; i++)
                for (int j = i; j < 5; j++)
                    for (int k = j; k < 5; k++)
                    {
                        parties.Add(new PartyDefinition(
                            new[] { BaseTypes[i], BaseTypes[j], BaseTypes[k] },
                            new UpgradeItemEnum?[] { null, null, null },
                            new UpgradeItemEnum?[] { null, null, null }
                        ));
                    }
            return parties;
        }

        public static List<PartyDefinition> GetTier1Parties()
        {
            var parties = new List<PartyDefinition>();
            for (int i = 0; i < 5; i++)
                for (int j = i; j < 5; j++)
                    for (int k = j; k < 5; k++)
                    {
                        var arch = new[] { BaseTypes[i], BaseTypes[j], BaseTypes[k] };
                        var uA = Tier1Upgrades[arch[0]];
                        var uB = Tier1Upgrades[arch[1]];
                        var uC = Tier1Upgrades[arch[2]];

                        for (int ai = 0; ai < uA.Length; ai++)
                            for (int bi = 0; bi < uB.Length; bi++)
                                for (int ci = 0; ci < uC.Length; ci++)
                                {
                                    if (i == j && ai >= bi) continue;
                                    if (j == k && bi >= ci) continue;

                                    parties.Add(new PartyDefinition(
                                        arch,
                                        new UpgradeItemEnum?[] { uA[ai], uB[bi], uC[ci] },
                                        new UpgradeItemEnum?[] { null, null, null }
                                    ));
                                }
                    }
            return parties;
        }

        private static List<PartyDefinition> _cachedTier2Parties;

        public static List<PartyDefinition> GetTier2Parties()
        {
            if (_cachedTier2Parties != null)
                return _cachedTier2Parties;

            var chainsByArchetype = new Dictionary<string, List<(UpgradeItemEnum t1, UpgradeItemEnum t2)>>();
            foreach (var bt in BaseTypes)
            {
                chainsByArchetype[bt] = new List<(UpgradeItemEnum, UpgradeItemEnum)>();
                foreach (var t1Item in Tier1Upgrades[bt])
                {
                    var t1Fighter = CreateFighter(bt, t1Item, null, 0);
                    if (Tier2Upgrades.ContainsKey(t1Fighter.CharacterType))
                    {
                        foreach (var t2Item in Tier2Upgrades[t1Fighter.CharacterType])
                            chainsByArchetype[bt].Add((t1Item, t2Item));
                    }
                }
            }

            var parties = new List<PartyDefinition>();
            for (int i = 0; i < 5; i++)
                for (int j = i; j < 5; j++)
                    for (int k = j; k < 5; k++)
                    {
                        var arch = new[] { BaseTypes[i], BaseTypes[j], BaseTypes[k] };
                        var cA = chainsByArchetype[arch[0]];
                        var cB = chainsByArchetype[arch[1]];
                        var cC = chainsByArchetype[arch[2]];

                        for (int ai = 0; ai < cA.Count; ai++)
                            for (int bi = 0; bi < cB.Count; bi++)
                                for (int ci = 0; ci < cC.Count; ci++)
                                {
                                    if (i == j && ai >= bi) continue;
                                    if (j == k && bi >= ci) continue;

                                    parties.Add(new PartyDefinition(
                                        arch,
                                        new UpgradeItemEnum?[] { cA[ai].t1, cB[bi].t1, cC[ci].t1 },
                                        new UpgradeItemEnum?[] { cA[ai].t2, cB[bi].t2, cC[ci].t2 }
                                    ));
                                }
                    }
            _cachedTier2Parties = parties;
            return parties;
        }

        public static List<PartyDefinition> GetTier2PartiesWithRecruits(RecruitSpec[] recruits)
        {
            var baseParties = GetTier2Parties();
            var parties = new List<PartyDefinition>(baseParties.Count * recruits.Length);
            foreach (var p in baseParties)
            {
                foreach (var recruit in recruits)
                    parties.Add(new PartyDefinition(p.BaseTypes, p.Tier1Items, p.Tier2Items, recruit));
            }
            return parties;
        }

        /// <summary>
        /// Returns a stratified random sample from the full party list. Every class that
        /// appears in the full list is guaranteed to appear in at least <paramref name="minPerClass"/>
        /// sampled parties, so the class breakdown remains directionally accurate.
        /// </summary>
        public static List<PartyDefinition> SampleParties(List<PartyDefinition> fullList, int sampleSize, int minPerClass = 5)
        {
            if (sampleSize >= fullList.Count)
                return fullList;

            var rng = new Random(42);
            var selected = new HashSet<int>();

            var classBuckets = new Dictionary<string, List<int>>();
            for (int i = 0; i < fullList.Count; i++)
            {
                var desc = fullList[i].Description;
                foreach (var className in desc.Split(" / "))
                {
                    if (!classBuckets.TryGetValue(className, out var bucket))
                    {
                        bucket = new List<int>();
                        classBuckets[className] = bucket;
                    }
                    bucket.Add(i);
                }
            }

            foreach (var bucket in classBuckets.Values)
            {
                int needed = Math.Min(minPerClass, bucket.Count);
                Shuffle(bucket, rng);
                for (int i = 0; i < needed && selected.Count < sampleSize; i++)
                    selected.Add(bucket[i]);
            }

            while (selected.Count < sampleSize)
                selected.Add(rng.Next(0, fullList.Count));

            var result = new List<PartyDefinition>(selected.Count);
            foreach (var idx in selected)
                result.Add(fullList[idx]);
            return result;
        }

        private static void Shuffle<T>(List<T> list, Random rng)
        {
            for (int i = list.Count - 1; i > 0; i--)
            {
                int j = rng.Next(0, i + 1);
                (list[i], list[j]) = (list[j], list[i]);
            }
        }
    }

    public class PartyDefinition
    {
        public string[] BaseTypes { get; }
        public UpgradeItemEnum?[] Tier1Items { get; }
        public UpgradeItemEnum?[] Tier2Items { get; }
        public RecruitSpec Recruit { get; }

        private readonly string _description;

        public PartyDefinition(string[] baseTypes, UpgradeItemEnum?[] tier1Items, UpgradeItemEnum?[] tier2Items, RecruitSpec recruit = null)
        {
            BaseTypes = baseTypes;
            Tier1Items = tier1Items;
            Tier2Items = tier2Items;
            Recruit = recruit;
            _description = BuildDescription();
        }

        public List<BaseFighter> CreateParty(int levelUps)
        {
            var party = new List<BaseFighter>();
            for (int i = 0; i < BaseTypes.Length; i++)
            {
                var fighter = PartyComposer.CreateFighter(BaseTypes[i], Tier1Items[i], Tier2Items[i], levelUps);
                fighter.CharacterName = $"Hero{i + 1}";
                party.Add(fighter);
            }
            if (Recruit != null)
            {
                party.Add(PartyComposer.CreateRecruit(Recruit));
            }
            return party;
        }

        public string Description => _description;

        private string BuildDescription()
        {
            var parts = new string[BaseTypes.Length + (Recruit != null ? 1 : 0)];
            for (int i = 0; i < BaseTypes.Length; i++)
            {
                parts[i] = PartyComposer.GetClassName(BaseTypes[i], Tier1Items[i], Tier2Items[i]);
            }
            if (Recruit != null)
                parts[BaseTypes.Length] = Recruit.Type;
            return string.Join(" / ", parts);
        }
    }
}
