using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Paladin : BaseFighter
    {
        public Paladin()
        {
            Abilities = new List<Ability>() { new Cure(), new Smash(), new Smite() };
            CharacterType = "Paladin";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Paladin(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Paladin(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 10;
            MaxHealth += 10;
            PhysicalAttack += 5;
            PhysicalDefense += 3;
            MagicAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(11, 14);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(4, 6);
            MagicDefense += random.Next(5, 8);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
