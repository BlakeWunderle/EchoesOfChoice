using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Monk : BaseFighter
    {
        public Monk()
        {
            Abilities = new List<Ability>() { new SpiritAttack(), new PreciseStrike(), new Meditate() };
            CharacterType = "Monk";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 3;
        }
        public Monk(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Monk(this);
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
            var healthIncrease = random.Next(12, 15);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(5, 8);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
