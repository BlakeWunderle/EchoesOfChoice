using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Siegemaster : BaseFighter
    {
        public Siegemaster()
        {
            Abilities = new List<Ability>() { new Earthquake(), new Demolish(), new Taunt() };
            CharacterType = "Siegemaster";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Siegemaster(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Siegemaster(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 12;
            MaxHealth += 12;
            PhysicalDefense += 5;
            PhysicalAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 13);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(3, 6);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
