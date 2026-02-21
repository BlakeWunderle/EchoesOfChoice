using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Astronomer : BaseFighter
    {
        public Astronomer()
        {
            Abilities = new List<Ability>() { new Starfall(), new MeteorShower(), new Eclipse() };
            CharacterType = "Astronomer";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Astronomer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Astronomer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(7, 10);
            MagicDefense += random.Next(5, 8);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
