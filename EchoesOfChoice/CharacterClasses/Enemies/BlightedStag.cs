using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class BlightedStag : BaseFighter
    {
        public BlightedStag(int level = 15)
        {
            Level = level;
            Health = Stat(240, 270, 7, 10, 15);
            MaxHealth = Health;
            PhysicalAttack = Stat(42, 50, 3, 5, 15);
            PhysicalDefense = Stat(22, 28, 2, 3, 15);
            MagicAttack = Stat(20, 26, 1, 3, 15);
            MagicDefense = Stat(20, 26, 1, 3, 15);
            Speed = Stat(34, 40, 3, 4, 15);
            Abilities = new List<Ability>() { new AntlerCharge(), new RotAura(), new Blight() };
            CharacterType = "Blighted Stag";
            Mana = Stat(22, 28, 2, 4, 15);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 4;
            DodgeChance = 18;
        }

        public BlightedStag(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new BlightedStag(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
