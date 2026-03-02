using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Harpy : BaseFighter
    {
        public Harpy(int level = 5)
        {
            Level = level;
            Health = Stat(96, 112, 4, 7, 5);
            MaxHealth = Health;
            PhysicalAttack = Stat(28, 33, 2, 4, 5);
            PhysicalDefense = Stat(10, 14, 1, 2, 5);
            MagicAttack = Stat(8, 12, 0, 2, 5);
            MagicDefense = Stat(12, 16, 1, 2, 5);
            Speed = Stat(28, 34, 2, 3, 5);
            Abilities = new List<Ability>() { new TalonRake(), new Shriek() };
            CharacterType = "Harpy";
            Mana = Stat(10, 14, 1, 3, 5);
            MaxMana = Mana;
            CritChance = 15;
            CritDamage = 2;
            DodgeChance = 25;
        }

        public Harpy(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Harpy(this);
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
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
