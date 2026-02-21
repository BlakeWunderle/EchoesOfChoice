using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Cryomancer : BaseFighter
    {
        public Cryomancer()
        {
            Abilities = new List<Ability>() { new Blizzard(), new Frostbite(), new Wall() };
            CharacterType = "Cryomancer";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Cryomancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Cryomancer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 5;
            MagicDefense += 5;
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
            PhysicalDefense += random.Next(3, 6);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
