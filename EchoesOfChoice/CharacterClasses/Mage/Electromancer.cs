using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Electromancer : BaseFighter
    {
        public Electromancer()
        {
            Abilities = new List<Ability>() { new Thunderbolt(), new ChainLightning(), new LightningRush() };
            CharacterType = "Electromancer";
            CritChance = 4;
            CritDamage = 3;
            DodgeChance = 2;
        }

        public Electromancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Electromancer(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            Speed += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
