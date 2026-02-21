using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Mime : BaseFighter
    {
        public Mime()
        {
            Abilities = new List<Ability>() { new InvisibleWall(), new Anvil(), new InvisibleBox() };
            CharacterType = "Mime";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
        }

        public Mime(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Mime(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 5;
            MagicDefense += 5;
            Mana += 5;
            MaxMana += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(5, 8);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(5, 8);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
