using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Tidecaller : BaseFighter
    {
        public Tidecaller()
        {
            Abilities = new List<Ability>() { new Purify(), new Tsunami(), new Undertow() };
            CharacterType = "Tidecaller";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Tidecaller(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Tidecaller(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 4;
            MagicDefense += 4;
            Health += 3;
            MaxHealth += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
