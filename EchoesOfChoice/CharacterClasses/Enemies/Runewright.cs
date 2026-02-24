using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Runewright : BaseFighter
    {
        public Runewright(int level = 10)
        {
            Level = level;
            Health = Stat(128, 163, 7, 12, 10);
            MaxHealth = Health;
            PhysicalAttack = Stat(38, 49, 3, 5, 10);
            PhysicalDefense = Stat(35, 46, 3, 5, 10);
            MagicAttack = Stat(42, 53, 3, 5, 10);
            MagicDefense = Stat(35, 46, 3, 5, 10);
            Speed = Stat(26, 37, 2, 4, 10);
            Abilities = new List<Ability>() { new RuneStrike(), new Inscribe(), new GlyphOfPower() };
            CharacterType = "Runewright";
            Mana = Stat(44, 65, 3, 6, 10);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Runewright(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Runewright(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
