using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Imp : BaseFighter
    {
        public Imp(int level = 16)
        {
            Level = level;
            Health = Stat(160, 190, 5, 8, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(12, 16, 0, 2, 16);
            PhysicalDefense = Stat(14, 18, 1, 2, 16);
            MagicAttack = Stat(38, 46, 3, 5, 16);
            MagicDefense = Stat(22, 28, 2, 3, 16);
            Speed = Stat(38, 44, 3, 5, 16);
            Abilities = new List<Ability>() { new Spark(), new Ember(), new Abilities.Enemy.Hex() };
            CharacterType = "Imp";
            Mana = Stat(34, 42, 3, 5, 16);
            MaxMana = Mana;
            CritChance = 18;
            CritDamage = 3;
            DodgeChance = 28;
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
