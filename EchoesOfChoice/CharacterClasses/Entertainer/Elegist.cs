using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Elegist : BaseFighter
    {
        public Elegist()
        {
            Abilities = new List<Ability>() { new Nightfall(), new Inspire(), new Dirge() };
            CharacterType = "Elegist";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }
        public Elegist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Elegist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 5;
            Speed += 5;
            MagicDefense += 3;
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
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(6, 9);
            MagicDefense += random.Next(7, 10);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
