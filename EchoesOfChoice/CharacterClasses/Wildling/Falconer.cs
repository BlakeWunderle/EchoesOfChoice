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
            CritChance = 1;
            CritDamage = 3;
            DodgeChance = 1;
        }

        public Falconer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Falconer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 4;
            Speed += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(3, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
