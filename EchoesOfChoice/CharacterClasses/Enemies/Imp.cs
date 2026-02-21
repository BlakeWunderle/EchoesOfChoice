using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Imp : BaseFighter
    {
        public Imp(int level = 4)
        {
            Level = level;
            Health = Stat(58, 80, 5, 10, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(7, 16, 1, 3, 4);
            PhysicalDefense = Stat(8, 16, 1, 3, 4);
            MagicAttack = Stat(16, 27, 2, 5, 4);
            MagicDefense = Stat(13, 24, 2, 5, 4);
            Speed = Stat(21, 32, 2, 5, 4);
            Abilities = new List<Ability>() { new Spark(), new Ember() };
            CharacterType = "Imp";
            Mana = Stat(26, 49, 2, 7, 4);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 2;
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
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
