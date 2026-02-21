using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Chanteuse : BaseFighter
    {
        public Chanteuse(int level = 6)
        {
            Level = level;
            Health = Stat(87, 97, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(16, 20, 0, 0, 6);
            PhysicalDefense = Stat(24, 28, 0, 0, 6);
            MagicAttack = Stat(36, 40, 0, 0, 6);
            MagicDefense = Stat(20, 24, 0, 0, 6);
            Speed = Stat(31, 35, 0, 0, 6);
            Abilities = new List<Ability>() { new Aria(), new Crescendo(), new Cadence() };
            CharacterType = "Chanteuse";
            Mana = Stat(34, 38, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
        }

        public Chanteuse(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Chanteuse(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
