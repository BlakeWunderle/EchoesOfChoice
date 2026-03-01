using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Wolf : BaseFighter
    {
        public Wolf(int level = 2)
        {
            Level = level;
            Health = Stat(50, 60, 4, 7, 2);
            MaxHealth = Health;
            PhysicalAttack = Stat(18, 22, 2, 3, 2);
            PhysicalDefense = Stat(8, 12, 1, 2, 2);
            MagicAttack = Stat(2, 4, 0, 1, 2);
            MagicDefense = Stat(6, 10, 1, 2, 2);
            Speed = Stat(24, 30, 2, 3, 2);
            Abilities = new List<Ability>() { new Bite(), new Howl() };
            CharacterType = "Wolf";
            Mana = Stat(6, 10, 1, 3, 2);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 15;
        }

        public Wolf(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Wolf(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(3, 6);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
