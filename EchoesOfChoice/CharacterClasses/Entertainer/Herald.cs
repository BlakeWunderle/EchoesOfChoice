using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Herald : BaseFighter
    {
        public Herald()
        {
            Abilities = new List<Ability>() { new Inspire(), new Proclamation(), new Decree() };
            CharacterType = "Herald";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Herald(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Herald(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 5;
            MaxHealth += 5;
            MagicAttack += 5;
            PhysicalAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(7, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(6, 9);
            MagicDefense += random.Next(5, 8);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
