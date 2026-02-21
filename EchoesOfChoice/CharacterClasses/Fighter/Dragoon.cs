using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Dragoon : BaseFighter
    {
        public Dragoon()
        {
            Abilities = new List<Ability>() { new Jump(), new WyvernStrike(), new DragonWard() };
            CharacterType = "Dragoon";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 2;
        }
        public Dragoon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Dragoon(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 8;
            MaxHealth += 8;
            PhysicalAttack += 5;
            MagicAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(14, 17);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
