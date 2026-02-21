using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Hydromancer : BaseFighter
    {
        public Hydromancer()
        {
            Abilities = new List<Ability>() { new Purify(), new Tsunami(), new Undertow()};
            CharacterType = "Hydromancer";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
        }

        public Hydromancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Hydromancer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 8;
            MaxHealth += 8;
            MagicAttack += 5;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
