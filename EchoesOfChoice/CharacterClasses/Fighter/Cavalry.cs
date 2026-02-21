using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Cavalry : BaseFighter
    {
        public Cavalry()
        {
            Abilities = new List<Ability>() { new Lance(), new Trample(), new Rally() };
            CharacterType = "Cavalry";
            CritChance = 3;
            CritDamage = 2;
            DodgeChance = 2;
        }

        public Cavalry(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Cavalry(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 4;
            MaxHealth += 4;
            PhysicalAttack += 3;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(14, 17);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(2, 5);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(4, 7);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
