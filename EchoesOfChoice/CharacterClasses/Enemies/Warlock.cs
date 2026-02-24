using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Warlock : BaseFighter
    {
        public Warlock(int level = 9)
        {
            Level = level;
            Health = Stat(91, 122, 5, 10, 9);
            MaxHealth = Health;
            PhysicalAttack = Stat(21, 31, 1, 3, 9);
            PhysicalDefense = Stat(20, 30, 1, 3, 9);
            MagicAttack = Stat(54, 68, 6, 9, 9);
            MagicDefense = Stat(26, 36, 2, 4, 9);
            Speed = Stat(30, 40, 2, 4, 9);
            Abilities = new List<Ability>() { new ShadowBolt(), new Hex(), new DarkPact() };
            CharacterType = "Warlock";
            Mana = Stat(48, 67, 4, 7, 9);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Warlock(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Warlock(this);
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
