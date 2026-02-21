using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Fiend : BaseFighter
    {
        public Fiend(int level = 9)
        {
            Level = level;
            Health = Stat(107, 127, 6, 12, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(26, 34, 1, 3, 9);
            PhysicalDefense = Stat(22, 30, 1, 3, 9);
            MagicAttack = Stat(48, 58, 6, 10, 9);
            MagicDefense = Stat(26, 34, 2, 4, 9);
            Speed = Stat(28, 36, 2, 4, 9);
            Abilities = new List<Ability>() { new Hellfire(), new Corruption(), new Torment() };
            CharacterType = "Fiend";
            Mana = Stat(55, 75, 4, 8, 9);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 2;
        }

        public Fiend(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Fiend(this);
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
