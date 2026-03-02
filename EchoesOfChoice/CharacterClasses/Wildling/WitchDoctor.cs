using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class WitchDoctor : BaseFighter
    {
        public WitchDoctor()
        {
            Abilities = new List<Ability>() { new VoodooBolt(), new DarkHex(), new CreepingRot() };
            CharacterType = "Witch Doctor";
            CritChance = 10;
            CritDamage = 2;
            DodgeChance = 15;
        }

        public WitchDoctor(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new WitchDoctor(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 12;
            MaxHealth += 12;
            MagicAttack += 10;
            Speed += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
