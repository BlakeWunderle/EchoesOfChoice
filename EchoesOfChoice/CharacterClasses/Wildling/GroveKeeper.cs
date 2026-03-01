using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class GroveKeeper : BaseFighter
    {
        public GroveKeeper()
        {
            Abilities = new List<Ability>() { new VineWall(), new RootTrap(), new Overgrowth() };
            CharacterType = "Grove Keeper";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public GroveKeeper(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new GroveKeeper(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 5;
            MaxHealth += 5;
            PhysicalDefense += 3;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(3, 5);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
