using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Bastion : BaseFighter
    {
        public Bastion()
        {
            Abilities = new List<Ability>() { new ShieldSlam(), new Fortify(), new Taunt() };
            CharacterType = "Bastion";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Bastion(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Bastion(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 15;
            MaxHealth += 15;
            PhysicalDefense += 5;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(18, 21);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(4, 7);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
