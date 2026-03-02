using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Falconer : BaseFighter
    {
        public Falconer()
        {
            Abilities = new List<Ability>() { new FalconStrike(), new SkyDive(), new RaptorsMark() };
            CharacterType = "Falconer";
            CritChance = 10;
            CritDamage = 3;
            DodgeChance = 10;
        }

        public Falconer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Falconer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 7;
            Speed += 5;
            Health += 5;
            MaxHealth += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
