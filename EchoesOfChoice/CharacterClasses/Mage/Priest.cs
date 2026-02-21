using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Priest : BaseFighter
    {
        public Priest()
        {
            Abilities = new List<Ability>() { new Restoration(), new HeavenlyBody(), new Holy() };
            CharacterType = "Priest";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Priest(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Priest(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            MagicDefense += 3;
            Mana += 8;
            MaxMana += 8;
            Health += 5;
            MaxHealth += 5;
            PhysicalDefense += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 13);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(6, 9);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
