using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Mindblast : Ability
    {
        public Mindblast()
        {
            Name = "Mindblast";
            FlavorText = "A wave of psychic energy surges outward, overwhelming the enemy's mind.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
