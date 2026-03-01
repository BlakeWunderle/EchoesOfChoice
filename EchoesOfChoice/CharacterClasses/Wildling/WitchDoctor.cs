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
            CritChance = 1;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public WitchDoctor(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new WitchDoctor(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 4;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
