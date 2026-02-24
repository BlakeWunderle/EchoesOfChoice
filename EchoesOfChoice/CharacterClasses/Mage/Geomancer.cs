using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Geomancer : BaseFighter
    {
        public Geomancer()
        {
            Abilities = new List<Ability>() { new Tremor(), new Lava(), new Wall() };
            CharacterType = "Geomancer";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Geomancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Geomancer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 5;
            MaxHealth += 5;
            MagicAttack += 5;
            PhysicalDefense += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(7, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(5, 8);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(6, 9);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
