using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class BearCub : BaseFighter
    {
        public BearCub(int level = 1)
        {
            Level = level;
            Health = Stat(50, 60, 3, 7);
            MaxHealth = Health;
            PhysicalAttack = Stat(10, 15, 2, 4);
            PhysicalDefense = Stat(4, 8, 2, 4);
            MagicAttack = Stat(2, 5, 1, 2);
            MagicDefense = Stat(4, 8, 1, 3);
            Speed = Stat(12, 22, 1, 3);
            Abilities = new List<Ability>() { new Claw() };
            CharacterType = "Bear Cub";
            CharacterName = "Roo";
            Mana = Stat(4, 8, 1, 3);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public BearCub(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new BearCub(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(3, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(1, 2);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
