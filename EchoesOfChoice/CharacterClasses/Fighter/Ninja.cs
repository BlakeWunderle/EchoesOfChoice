using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Ninja : BaseFighter
    {
        public Ninja()
        {
            Abilities = new List<Ability>() { new SweepingSlash(), new Dash(), new SmokeBomb() };
            CharacterType = "Ninja";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 3;
        }
        public Ninja(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Ninja(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 5;
            Speed += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(12, 15);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(4, 7);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
