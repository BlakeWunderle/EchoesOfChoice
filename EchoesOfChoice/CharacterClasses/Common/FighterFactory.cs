using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Fighter;
using EchoesOfChoice.CharacterClasses.Mage;
using EchoesOfChoice.CharacterClasses.Entertainer;
using EchoesOfChoice.CharacterClasses.Scholar;
using EchoesOfChoice.CharacterClasses.Enemies;

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
            { "Scholar", () => new Scholar.Scholar() },

            // Fighter tier 1
            { "Duelist", () => new Duelist() },
            { "Warden", () => new Warden() },
            { "Ranger", () => new Ranger() },
            { "MartialArtist", () => new MartialArtist() },

            // Fighter tier 2
            { "Knight", () => new Knight() },
            { "Cavalry", () => new Cavalry() },
            { "Bastion", () => new Bastion() },
            { "Hunter", () => new Hunter() },
            { "Ninja", () => new Ninja() },
            { "Monk", () => new Monk() },
            { "Mercenary", () => new Mercenary() },
            { "Dragoon", () => new Dragoon() },

            // Mage tier 1
            { "Mistweaver", () => new Mistweaver() },
            { "Firebrand", () => new Firebrand() },
            { "Acolyte", () => new Acolyte() },
            { "Stormcaller", () => new Stormcaller() },

            // Mage tier 2
            { "Tempest", () => new Tempest() },
            { "Pyromancer", () => new Pyromancer() },
            { "Hydromancer", () => new Hydromancer() },
            { "Cryomancer", () => new Cryomancer() },
            { "Electromancer", () => new Electromancer() },
            { "Geomancer", () => new Geomancer() },
            { "Paladin", () => new Paladin() },
            { "Priest", () => new Priest() },

            // Entertainer tier 1
            { "Bard", () => new Bard() },
            { "Dervish", () => new Dervish() },
            { "Orator", () => new Orator() },
            { "Chorister", () => new Chorister() },

            // Entertainer tier 2
            { "Herald", () => new Herald() },
            { "Laureate", () => new Laureate() },
            { "Mime", () => new Mime() },
            { "Minstrel", () => new Minstrel() },
            { "Muse", () => new Muse() },
            { "Warcrier", () => new Warcrier() },
            { "Elegist", () => new Elegist() },
            { "Illusionist", () => new Illusionist() },

            // Scholar tier 1
            { "Artificer", () => new Artificer() },
            { "Cosmologist", () => new Cosmologist() },
            { "Tinker", () => new Tinker() },
            { "Arithmancer", () => new Arithmancer() },

            // Scholar tier 2
            { "Astronomer", () => new Astronomer() },
            { "Siegemaster", () => new Siegemaster() },
            { "Alchemist", () => new Alchemist() },
            { "Thaumaturge", () => new Thaumaturge() },
            { "Automaton", () => new Automaton() },
            { "Bombardier", () => new Bombardier() },
            { "Technomancer", () => new Technomancer() },
            { "Chronomancer", () => new Chronomancer() },

            // Recruitable enemies (from ReturnToCity battles)
            { "Seraph", () => new Seraph() },
            { "Fiend", () => new Fiend() },
            { "Druid", () => new Druid() },
            { "Necromancer", () => new Necromancer() },
            { "Psion", () => new Psion() },
            { "Runewright", () => new Runewright() },
            { "Shaman", () => new Shaman() },
            { "Warlock", () => new Warlock() },
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
