using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Hunter : BaseFighter
    {
        public Hunter()
        {
            Abilities = new List<Ability>() { new TripleArrow(), new Snare(), new HuntersMark() };
            CharacterType = "Hunter";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 4;
        }

        public Hunter(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Hunter(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 3;
            MaxHealth += 3;
            PhysicalAttack += 2;
            Speed += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(13, 16);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(5, 8);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
