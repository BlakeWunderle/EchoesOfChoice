using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Wisp : BaseFighter
    {
        public Wisp(int level = 4)
        {
            Level = level;
            Health = Stat(47, 66, 4, 8, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(6, 10, 1, 2, 4);
            PhysicalDefense = Stat(7, 11, 1, 2, 4);
            MagicAttack = Stat(18, 28, 2, 5, 4);
            MagicDefense = Stat(9, 16, 1, 3, 4);
            Speed = Stat(25, 34, 3, 5, 4);
            Abilities = new List<Ability>() { new Lure(), new Bewitch() };
            CharacterType = "Wisp";
            Mana = Stat(24, 40, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 3;
        }

        public Wisp(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Wisp(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 5);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(3, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
