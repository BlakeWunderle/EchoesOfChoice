using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Shaman : BaseFighter
    {
        public Shaman(int level = 9)
        {
            Level = level;
            Health = Stat(124, 152, 8, 13, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(31, 41, 2, 4, 9);
            PhysicalDefense = Stat(34, 44, 3, 5, 9);
            MagicAttack = Stat(35, 45, 3, 5, 9);
            MagicDefense = Stat(34, 44, 3, 5, 9);
            Speed = Stat(20, 30, 1, 3, 9);
            Abilities = new List<Ability>() { new SpiritBolt(), new Rejuvenate(), new AncestralWard() };
            CharacterType = "Shaman";
            Mana = Stat(41, 60, 3, 6, 9);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Shaman(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shaman(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
