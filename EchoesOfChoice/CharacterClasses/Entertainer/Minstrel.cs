using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Minstrel : BaseFighter
    {
        public Minstrel()
        {
            Abilities = new List<Ability>() { new Ballad(), new Frustrate(), new Serenade() };
            CharacterType = "Minstrel";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Minstrel(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Minstrel(this);
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
            var healthIncrease = random.Next(4, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(5, 8);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 6);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
