using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;
using System;
using EchoesOfChoice.CharacterClasses.Abilities;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Knight : BaseFighter
    {
        public Knight()
        {
            Abilities = new List<Ability>() { new Block(), new Valor(), new Aegis() };
            CharacterType = "Knight";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Knight(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Knight(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 12;
            MaxHealth += 12;
            PhysicalDefense += 5;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(16, 19);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(5, 8);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
