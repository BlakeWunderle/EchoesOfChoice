using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Illusionist : BaseFighter
    {
        public Illusionist()
        {
            Abilities = new List<Ability>() { new ShadowAttack(), new Mirage(), new Bewilderment() };
            CharacterType = "Illusionist";
            CritChance = 3;
            CritDamage = 2;
            DodgeChance = 4;
        }
        public Illusionist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Illusionist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 7;
            Speed += 5;
            Health += 5;
            MaxHealth += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 13);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(3, 6);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
