using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Fighter;
using EchoesOfChoice.CharacterClasses.Mage;
using EchoesOfChoice.CharacterClasses.Entertainer;
using EchoesOfChoice.CharacterClasses.Scholar;
using EchoesOfChoice.CharacterClasses.Enemies;
using EchoesOfChoice.CharacterClasses.Wildling;

namespace EchoesOfChoice.CharacterClasses.Common
{
    public static class FighterFactory
    {
        private static readonly Dictionary<string, Func<BaseFighter>> Constructors = new Dictionary<string, Func<BaseFighter>>
        {
            // Base classes
            { "Squire", () => new Squire() },
            { "Mage", () => new Mage.Mage() },
            { "Entertainer", () => new Entertainer.Entertainer() },
            { "Tinker", () => new Scholar.Scholar() },

            // Fighter tier 1
            { "Duelist", () => new Duelist() },
            { "Ranger", () => new Ranger() },
            { "MartialArtist", () => new MartialArtist() },

            // Fighter tier 2
            { "Cavalry", () => new Cavalry() },
            { "Hunter", () => new Hunter() },
            { "Ninja", () => new Ninja() },
            { "Monk", () => new Monk() },
            { "Mercenary", () => new Mercenary() },
            { "Dragoon", () => new Dragoon() },

            // Mage tier 1
            { "Invoker", () => new Invoker() },
            { "Acolyte", () => new Acolyte() },

            // Mage tier 2
            { "Infernalist", () => new Infernalist() },
            { "Tidecaller", () => new Tidecaller() },
            { "Tempest", () => new Tempest() },
            { "Paladin", () => new Paladin() },
            { "Priest", () => new Priest() },
            { "Warlock", () => new Mage.Warlock() },

            // Entertainer tier 1
            { "Bard", () => new Bard() },
            { "Dervish", () => new Dervish() },
            { "Orator", () => new Orator() },

            // Entertainer tier 2
            { "Laureate", () => new Laureate() },
            { "Mime", () => new Mime() },
            { "Minstrel", () => new Minstrel() },
            { "Warcrier", () => new Warcrier() },
            { "Elegist", () => new Elegist() },
            { "Illusionist", () => new Illusionist() },

            // Tinker tier 1
            { "Artificer", () => new Artificer() },
            { "Philosopher", () => new Cosmologist() },
            { "Arithmancer", () => new Arithmancer() },

            // Tinker tier 2
            { "Astronomer", () => new Astronomer() },
            { "Alchemist", () => new Alchemist() },
            { "Bombardier", () => new Bombardier() },
            { "Automaton", () => new Automaton() },
            { "Technomancer", () => new Technomancer() },
            { "Chronomancer", () => new Chronomancer() },

            // Wildling base
            { "Wildling", () => new Wildling.Wildling() },

            // Wildling tier 1
            { "Herbalist", () => new Herbalist() },
            { "Shaman", () => new Wildling.Shaman() },
            { "Beastcaller", () => new Beastcaller() },

            // Wildling tier 2
            { "Blighter", () => new Blighter() },
            { "Grove Keeper", () => new GroveKeeper() },
            { "Witch Doctor", () => new WitchDoctor() },
            { "Spiritwalker", () => new Spiritwalker() },
            { "Falconer", () => new Falconer() },
            { "Shapeshifter", () => new Shapeshifter() },

            // Recruitable enemies (from ReturnToCity battles)
            { "Seraph", () => new Seraph() },
            { "Fiend", () => new Fiend() },
            { "Druid", () => new Druid() },
            { "Necromancer", () => new Necromancer() },
            { "Psion", () => new Psion() },
            { "Runewright", () => new Runewright() },
        };

        public static BaseFighter CreateFighter(FighterSaveData data)
        {
            if (!Constructors.TryGetValue(data.ClassId, out var constructor))
            {
                throw new ArgumentException($"Unknown fighter class: {data.ClassId}");
            }

            var fighter = constructor();
            fighter.ApplySaveData(data);
            return fighter;
        }
    }
}
