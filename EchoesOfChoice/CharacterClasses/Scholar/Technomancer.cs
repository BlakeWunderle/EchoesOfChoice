using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Technomancer : BaseFighter
    {
        public Technomancer()
        {
            Abilities = new List<Ability>() { new Random(), new ProgramDefense(), new ProgramOffense() };
            CharacterType = "Technomancer";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Technomancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Technomancer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            Mana += 5;
            MaxMana += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(14, 17);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(7, 10);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
