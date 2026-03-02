using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Imp : BaseFighter
    {
        public Imp(int level = 18)
        {
            Level = level;
            Health = Stat(250, 290, 7, 10, 18);
            MaxHealth = Health;
            PhysicalAttack = Stat(14, 18, 0, 2, 18);
            PhysicalDefense = Stat(18, 24, 1, 3, 18);
            MagicAttack = Stat(68, 78, 5, 7, 18);
            MagicDefense = Stat(28, 34, 2, 4, 18);
            Speed = Stat(44, 50, 3, 5, 18);
            Abilities = new List<Ability>() { new Spark(), new Ember(), new Abilities.Enemy.Hex() };
            CharacterType = "Imp";
            Mana = Stat(40, 48, 3, 5, 18);
            MaxMana = Mana;
            CritChance = 26;
            CritDamage = 4;
            DodgeChance = 30;
        }

        public Imp(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Imp(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(2, 5);
            MagicDefense += random.Next(2, 5);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
