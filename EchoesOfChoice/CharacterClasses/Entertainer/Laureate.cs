using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Laureate : BaseFighter
    {
        public Laureate()
        {
            Abilities = new List<Ability>() { new Ovation(), new Recite(), new Eulogy() };
            CharacterType = "Laureate";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Laureate(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Laureate(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            MagicDefense += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(6, 9);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(7, 10);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new NotImplementedException();
        }
    }
}
